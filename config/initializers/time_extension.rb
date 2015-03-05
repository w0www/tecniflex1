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

  def self.formathms(seg)
	dura = ""
      if seg == nil 
        dura = "00:00:00"
      else
        horas = (seg/3600).to_i
        minutos =  (seg/60 - horas * 60).to_i
        segundos = (seg - (minutos*60 + horas*3600)).to_i
        dura =  horas.to_s + ":" + minutos.to_s + ":" + segundos.to_s
      end
  end
  

	
end
