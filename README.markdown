# PoormansCron

http://github.com/jugyo/poormans_cron

## Description

PoormansCron is a poor man's cron.

## Usage

### Create a table

Create a table named 'poormans_crons' as following:

    create_table :poormans_crons, :force => true do |t|
      t.column :id,           :integer
      t.column :name,         :integer
      t.column :interval,     :integer
      t.column :performed_at, :datetime
    end

### Create cron

    PoormansCron::Cron.create(:name => 'foo', :interval => 60)

### Register jobs

    PoormansCron.register_job(:foo) do
      # do something
    end

Copyright (c) 2009 jugyo, released under the MIT license
