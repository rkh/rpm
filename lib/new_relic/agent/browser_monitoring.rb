module NewRelic
  module Agent
    module BrowserMonitoring
      def browser_instrumentation_header(options={})
  <<-eos
  <!-- generated by the New Relic agent -->
  <script type="text/javascript" charset="utf-8">
    if ( "undefined" == typeof(window.postMessage)) {
      window.postMessage = function() {};
    } else {
      EPISODES.setBeacon("#{Rails.env.development? ? 'localhost:9000' : 'staging-beacon.newrelic.com'}");
      EPISODES.setAccountId(1);
      EPISODES.setApplicationName("#{NewRelic::Control.instance.app_names.join(';')}");
      EPISODES.setTransactionName("#{Thread::current[:newrelic_scope_name]}");
    
      EPISODES.expects('frontend', 'totaltime');
  
      window.postMessage("EPISODES:mark:firstbyte", "*");
      window.postMessage("EPISODES:measure:backend:starttime", "*");
  
      function doPageReady() { 
        window.postMessage("EPISODES:measure:frontend:firstbyte", "*");
        // don't need 'page ready' since it can be computed as backend + frontend
        // window.postMessage("EPISODES:measure:pageready:starttime", "*");
        // totaltime measure used to be handled in rpm.chart.js/rpm.highcharts.js to account for
        // asynch loads of graphs. Needs to be re-visited - for now just measure on page load.
        window.postMessage("EPISODES:measure:totaltime:starttime", "*");
        window.postMessage("EPISODES:done", "*");
      }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
      
      EPISODES.addEventListener("load", doPageReady, false);
    }
  </script>
  eos
      end
      
      def browser_instrumentation_footer(options={})
        #this is a total hack
        begin_time = (Thread.current[:started_on].to_f * 1000).round
        frame = Thread.current[:newrelic_metric_frame]

        if frame
          end_time = (frame.start.to_f * 1000).round
        else
          #this is a total hack
          end_time = begin_time + 250
        end
 
  <<-eos
  <!-- generated by the New Relic agent -->
  <script type="text/javascript" charset="utf-8">
      window.postMessage("EPISODES:mark:qstart:#{begin_time}", "*");
      window.postMessage("EPISODES:mark:qend:#{end_time}", "*");
      window.postMessage("EPISODES:measure:qtime:qstart:qend", "*");
      window.postMessage("EPISODES:mark:appstart:#{begin_time}", "*");
      window.postMessage("EPISODES:mark:append:#{(Time.now.to_f * 1000).round}", "*");
      window.postMessage("EPISODES:measure:apptime:appstart:append", "*");
  </script>
  eos
      end
    end
  end
end