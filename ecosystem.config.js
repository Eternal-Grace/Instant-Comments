module.exports = {
  apps : [
    {
      name          : 'IM--FRONT', // App name that shows in `pm2 ls`
      exec_mode     : 'cluster', // enables clustering
      instances     : 4, // or an integer
      cwd           : './_frontend', // only if using a subdirectory
      script        : './node_modules/nuxt/bin/nuxt.js', // The magic key
      args          : 'start',
      error_file:   'logs/err.log',
      out_file:     'logs/out.log',
      log_file:     'logs/combined.log',
    },
    {
      name          : 'IM--ECHO-SERVER', // App name that shows in `pm2 ls`
      exec_mode     : 'cluster', // enables clustering
      instances     : 1,
      cwd           : './_echo', // only if using a subdirectory
      script        : 'laravel-echo-server', // The magic key
      interpreter   : 'php',
      args          : 'start --force',
      error_file:   'logs/err.log',
      out_file:     'logs/out.log',
      log_file:     'logs/combined.log',
    },
    {
      name          : 'IM--BACK-QUEUE-WORKER', // App name that shows in `pm2 ls`
      exec_mode     : 'fork', // enables clustering
      instances     : 1,
      cwd           : './_backend', // only if using a subdirectory
      script        : 'artisan', // The magic key
      interpreter   : 'php',
      args          : 'queue:work --queue=default --sleep=3',
      error_file:   'logs/err.log',
      out_file:     'logs/out.log',
      log_file:     'logs/combined.log',
    },
    {
      name:         'IM--BACK-SERVER',
      instances:    1,
      cwd           : './_backend',
      script:       'artisan',
      interpreter:  'php',
      args:         ['serve'],
      wait_ready:   true,
      autorestart:  false,
      max_restarts: 1,
      watch:        true,
      error_file:   'logs/err.log',
      out_file:     'logs/out.log',
      log_file:     'logs/combined.log',
      time:         true
    }
  ]
};
