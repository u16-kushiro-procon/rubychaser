#!/usr/bin/env ruby
# encoding: utf-8

require 'jrubyfx'

class RubyClientSetting < JRubyFX::Application
  def start(stage)
    with(stage, title: 'Client Setting', width: 200, height: 150) do
      server_box = nil
      port_box = nil
      name_box = nil
      klass_box = nil
      start_button = nil

      scene = layout_scene do
        vbox do
          hbox do
            label('server')
            server_box = combo_box(observable_array_list(['localhost']))
            server_box.set_editable(true)
          end
          hbox do
            label('port')
            #port_field = text_field
            port_box = combo_box(observable_array_list(['2009', '2010']))
            port_box.set_editable(true)
          end
          hbox do
            label('name')
            name_box = combo_box
            name_box.set_editable(true)
          end
          hbox do
            label('class')
            klass_box = combo_box
            klass_box.set_editable(true)
          end
          start_button = button('Start!') do
            set_on_action do
              if server_box.value == ''
                puts "IPアドレスが設定されていません．"
                next
              else
                puts server_box.value
              end
              puts port_box.value
              puts name_box.value
              puts klass_box.value
              system("ruby ./main.rb --host=#{server_box.value} --port=#{port_box.value} --username=#{name_box.value} --chaser=#{klass_box.value}")
            end
          end

        end
      end

      show
    end
  end

  def stop
    puts 'クライアントを終了します...'
  end
end

RubyClientSetting.launch
