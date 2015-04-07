# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Function.create name: 'non-bottlneck function'
Function.create name: 'direct and indirect bottleneck function'
Function.create name: 'indirect bottleneck function'
Function.create name: 'direct bottleneck function'

App.create name: 'sar'
App.create name: 'ftl'

DataSet.create name: 'tiny', size: 2
DataSet.create name: 'small', size: 3
DataSet.create name: 'normal', size: 4
DataSet.create name: 'large', size: 5
DataSet.create name: 'huge', size: 6


Run.create app_id: 1, data_set_id: 1, thread_count: 1, run_time: 100
Entry.create run_id: 1, function_id: 1, run_time: 10, run_time_no_calls: 1, calls: 1
Entry.create run_id: 1, function_id: 2, run_time: 10, run_time_no_calls: 1, calls: 1
Entry.create run_id: 1, function_id: 3, run_time: 10, run_time_no_calls: 1, calls: 1
Entry.create run_id: 1, function_id: 4, run_time: 10, run_time_no_calls: 10, calls: 1


Run.create app_id: 1, data_set_id: 1, thread_count: 2, run_time: 200
Entry.create run_id: 2, function_id: 1, run_time: 20, run_time_no_calls: 2, calls: 2
Entry.create run_id: 2, function_id: 2, run_time: 40, run_time_no_calls: 4, calls: 2
Entry.create run_id: 2, function_id: 3, run_time: 40, run_time_no_calls: 2, calls: 2
Entry.create run_id: 2, function_id: 4, run_time: 40, run_time_no_calls: 40, calls: 2



Run.create app_id: 1, data_set_id: 1, thread_count: 4, run_time: 400
Entry.create run_id: 3, function_id: 1, run_time: 40, run_time_no_calls: 4, calls: 4
Entry.create run_id: 3, function_id: 2, run_time: 80, run_time_no_calls: 16, calls: 4
Entry.create run_id: 3, function_id: 3, run_time: 80, run_time_no_calls: 4, calls: 4
Entry.create run_id: 3, function_id: 4, run_time: 80, run_time_no_calls: 80, calls: 4



Run.create app_id: 1, data_set_id: 1, thread_count: 8, run_time: 800
Entry.create run_id: 4, function_id: 1, run_time: 80, run_time_no_calls: 8, calls: 8
Entry.create run_id: 4, function_id: 2, run_time: 160, run_time_no_calls: 64, calls: 8
Entry.create run_id: 4, function_id: 3, run_time: 160, run_time_no_calls: 8, calls: 8
Entry.create run_id: 4, function_id: 4, run_time: 160, run_time_no_calls: 160, calls: 8






Run.create app_id: 2, data_set_id: 1, thread_count: 1, run_time: 100
Entry.create run_id: 5, function_id: 1, run_time: 10, run_time_no_calls: 1, calls: 1
Entry.create run_id: 5, function_id: 2, run_time: 10, run_time_no_calls: 1, calls: 1
Entry.create run_id: 5, function_id: 3, run_time: 10, run_time_no_calls: 1, calls: 1
Entry.create run_id: 5, function_id: 4, run_time: 10, run_time_no_calls: 10, calls: 1


Run.create app_id: 2, data_set_id: 2, thread_count: 1, run_time: 200
Entry.create run_id: 6, function_id: 1, run_time: 20, run_time_no_calls: 2, calls: 2
Entry.create run_id: 6, function_id: 2, run_time: 40, run_time_no_calls: 4, calls: 2
Entry.create run_id: 6, function_id: 3, run_time: 40, run_time_no_calls: 2, calls: 2
Entry.create run_id: 6, function_id: 4, run_time: 40, run_time_no_calls: 40, calls: 2



Run.create app_id: 2, data_set_id: 3, thread_count: 1, run_time: 400
Entry.create run_id: 7, function_id: 1, run_time: 40, run_time_no_calls: 4, calls: 4
Entry.create run_id: 7, function_id: 2, run_time: 80, run_time_no_calls: 16, calls: 4
Entry.create run_id: 7, function_id: 3, run_time: 80, run_time_no_calls: 4, calls: 4
Entry.create run_id: 7, function_id: 4, run_time: 80, run_time_no_calls: 80, calls: 4



Run.create app_id: 2, data_set_id: 4, thread_count: 1, run_time: 800
Entry.create run_id: 8, function_id: 1, run_time: 80, run_time_no_calls: 8, calls: 8
Entry.create run_id: 8, function_id: 2, run_time: 160, run_time_no_calls: 64, calls: 8
Entry.create run_id: 8, function_id: 3, run_time: 160, run_time_no_calls: 8, calls: 8
Entry.create run_id: 8, function_id: 4, run_time: 160, run_time_no_calls: 160, calls: 8
