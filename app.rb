#!/usr/bin/env ruby
require 'bundler'
Bundler.require
require "sinatra/activerecord"

require 'will_paginate'
require 'will_paginate/active_record'

require 'kronic'

register Sinatra::ActiveRecordExtension
register WillPaginate::Sinatra

ActiveRecord::Base.logger = nil

set :database, {adapter: "sqlite3", database: "flparser.sqlite3"}

set :bind, '0.0.0.0'
set :server, 'webrick'
FEEDS = %w(
  http://freelansim.ru/rss/tasks
  https://www.fl.ru/rss/all.xml
  http://www.weblancer.net/rss/projects.rss
)

UAs = [
  'Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0',
  'Mozilla/5.0 (X11; OpenBSD amd64; rv:28.0) Gecko/20100101 Firefox/28.0',
  'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1944.0 Safari/537.36',
  'Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14',
  'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)'
]

class Project < ActiveRecord::Base
  @@skip_categories = \
    %w(Дизайн Тексты Оптимизация Фотография Архитектура Графика
      Мероприятия Переводы Аудио Видео Реклама Маркетинг Обучение
      Полиграфия Инжиниринг Арт Флеш Анимация 1С-программирование
      Рерайт Бухгалтерия
    )

  scope :category_filter, ->{where @@skip_categories.map{|w| "category not like '%#{w}%'"}.join(' AND ')+" OR category is null"}
  scope :weblancer, -> {where "uri like '%weblancer.net%'"}
  scope :freelansim, -> {where "uri like '%freelansim.ru%'"}
  scope :fl, -> {where "uri like '%fl.ru%'"}
  scope :not_viewed, ->{ where(viewed_at: nil) }

  def self.create_from_parsed_data project, site
    p = Project.new remote_id: project.id,
      title: project.title, body: project.body,
      uri: project.uri, category: project.category,
      site: site, published: project.published
    if project.budget
      p.budget_origin = project.budget.origin
      p.budget_amount = project.budget.amount
      p.budget_currency = project.budget.currency
    end
    p.save!
  end
end

get '/' do
  @start_at = Time.now
  @projects = Project.category_filter
  @projects = @projects.not_viewed
  @total = @projects.count
  @projects = @projects.order('published desc')
  @projects = @projects.paginate(page: params[:page], per_page: 20)
  @projects.each {|p| p.viewed_at = Time.now; p.save!}
  slim :index
end

get '/viewed' do
  @start_at = Time.now
  @projects = Project.where('viewed_at is not null').order('viewed_at desc')
  @projects = @projects.paginate(page: params[:page], per_page: 200)
  slim :index
end
