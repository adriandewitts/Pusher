group = 'pusher'

default = DefaultConfig.new(:root => '/home/ubuntu/pusher')

God.watch do |w|
  name = group + '-passenger'
  default.with(w, :name => name, :group => group)
  w.start    = default.bundle_cmd 'thin start -d -S /tmp/appiphany-pusher.sock -e production'
  w.pid_file = "#{default[:root]}/shared/pids/thin.pid"  
  w.unix_socket = "/tmp/appiphany-pusher.sock"

  w.behavior :clean_unix_socket
  
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 20.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  name = group + '-feeder'
  default.with(w, :name => name, :group => group)  

  w.start = default.bundle_cmd "#{default[:root]}/current/script/pusher production -p #{default[:root]}/shared/pids/pusher.pid"
  w.stop = "kill `cat #{default[:root]}/shared/pids/pusher.pid`"
  w.pid_file = "#{default[:root]}/shared/pids/pusher.pid"
  w.behavior(:clean_pid_file)

  w.keepalive

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 20.seconds
      c.running = false
    end
  end
    
  w.restart_if do |on|
    on.condition(:lambda) do |c|
      c.lambda = lambda{
        watching_file = '/tmp/pusher-feeder-last-start.tmp'
        begin
          if (Time.now - File.mtime(watching_file) > 4.hours)
            `touch #{watching_file}`
            true
          else
            false
          end
        rescue
           `touch #{watching_file}`
           true 
        end 
       }           
    end
  end 
    
  
end
