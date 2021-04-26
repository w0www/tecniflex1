require 'fastercsv'

Rails.logger.info "GOMILOG: EMPEZAMOS A IMPORTAR TAREAS POLIMERO"

csv_text = File.read("#{Rails.root}/doc/polimeros.csv")
csv = CSV.parse(csv_text, :headers => true)
# Tipoesko = OrdTrab
# Horas = Intervencion
csv.each do |row|
  orden = OrdTrab.find_by_numOT(row["OT"])
  if orden
    Rails.logger.info "GOMILOG: TAREA #{orden.id} - #{orden.numOT} ACTUALIZANDO"
    Rails.logger.info "GOMILOG: row ESKO1 #{row["ESKO 1"]}"
    if row["ESKO 1"] == "X"
      orden.update_attribute(:tipoesko, "esko1")
    elsif row["ESKO 2"] == "X"
      orden.update_attribute(:tipoesko, "esko2")
    elsif row["TERMOF"] == "X"
      orden.update_attribute(:tipoesko, "esko2")
    end
    if row["DPC"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("DPC"))
    elsif row["DPU"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("DPU"))
    elsif row["DPN"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("DPN"))
    elsif row["DIG"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("DIG"))
    elsif row["MAX"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("MAX"))
    elsif row["FAM"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("FAM"))
    elsif row["DPR"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("DPR"))
    elsif row["ARTD"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("ARTD"))
    elsif row["ELASLON"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("ELASLON"))
    elsif row["DUPONT"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("DUPONT"))
    elsif row["ACE"] == "X"
      orden.update_attribute(:tipomat, Tipomat.find_by_nombre("ACE"))
    end
    if row["1,14"] == "X"
      orden.update_attribute(:espesor, Espesor.find_by_calibre("1.14"))
    elsif row["1,7"] == "X"
      orden.update_attribute(:espesor, Espesor.find_by_calibre("1.7"))
    elsif row["2,84"] == "X"
      orden.update_attribute(:espesor, Espesor.find_by_calibre("2.84"))
    elsif row["6,35"] == "X"
      orden.update_attribute(:espesor, Espesor.find_by_calibre("6.35"))
    end

    orden.separacions.delete_all
    orden.separacions << Separacion.create(:color => row["1"], :ord_trab_id => orden.id) if !row["1"].blank?
    orden.separacions << Separacion.create(:color => row["2"], :ord_trab_id => orden.id) if !row["2"].blank?
    orden.separacions << Separacion.create(:color => row["3"], :ord_trab_id => orden.id) if !row["3"].blank?
    orden.separacions << Separacion.create(:color => row["4"], :ord_trab_id => orden.id) if !row["4"].blank?
    orden.separacions << Separacion.create(:color => row["5"], :ord_trab_id => orden.id) if !row["5"].blank?
    orden.separacions << Separacion.create(:color => row["6"], :ord_trab_id => orden.id) if !row["6"].blank?

    # Buscamos la intervencion del polimero
    intervencion = Tarea.find(:all, :conditions => ["ord_trab_id = ? AND proceso_id = 7", orden.id]).first.intervencions.last
    if intervencion
      intervencion.update_attributes(:hora_entrada => row["HORA ENT."] , :hora_salida => row["HORA SAL."], :operador => row["OPERADOR"], :acabado => row["ACABADO"])
    end
    Rails.logger.info "GOMILOG: TAREA #{orden.id} - #{orden.numOT} ACTUALIZADA"
  else
    Rails.logger.info "GOMILOG: ERROR ACTUALIZANDO TAREA #{row['OT']}"
  end
end
Rails.logger.info "GOMILOG: TAREA DE ACTUALIZACION TERMINADA"
