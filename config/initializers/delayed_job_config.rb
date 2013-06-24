#Si falla el envio de emails, prueba a enviarlo 2880 veces cada 30 segundos, es decir, 24 horas.

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 30
Delayed::Worker.max_attempts = 2880
Delayed::Worker.max_run_time = 5.minutes
