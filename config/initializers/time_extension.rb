class Time
  def self.duracion(ini,fin)
      dura = ""
      if fin == nil || fin == ""
        dura = "No term."
      else
        dife = fin - ini
        horas = (dife/3600).to_i
        minutos =  (dife/60 - horas * 60).to_i
        segundos = (dife - (minutos*60 + horas*3600)).to_i
        dura =  horas.to_s + ":" + minutos.to_s + ":" + segundos.to_s
      end
  end
end
