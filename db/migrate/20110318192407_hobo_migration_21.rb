class HoboMigration21 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :mpFTP, :boolean
    add_column :ord_trabs, :mpFTPq, :integer
    add_column :ord_trabs, :mpFTPdev, :boolean
    add_column :ord_trabs, :mpPel, :boolean
    add_column :ord_trabs, :mpPelq, :integer
    add_column :ord_trabs, :mpPeldev, :boolean
    add_column :ord_trabs, :mpImp, :boolean
    add_column :ord_trabs, :mpImpq, :integer
    add_column :ord_trabs, :mpImpdev, :boolean
    add_column :ord_trabs, :mpMgr, :boolean
    add_column :ord_trabs, :mpMgrq, :integer
    add_column :ord_trabs, :mpMgrdev, :boolean
    add_column :ord_trabs, :mpOpt, :boolean
    add_column :ord_trabs, :mpOptq, :integer
    add_column :ord_trabs, :mpOptdev, :boolean
    add_column :ord_trabs, :mpPtr, :boolean
    add_column :ord_trabs, :mpPtrq, :integer
    add_column :ord_trabs, :mpPtrdev, :boolean
  end

  def self.down
    remove_column :ord_trabs, :mpFTP
    remove_column :ord_trabs, :mpFTPq
    remove_column :ord_trabs, :mpFTPdev
    remove_column :ord_trabs, :mpPel
    remove_column :ord_trabs, :mpPelq
    remove_column :ord_trabs, :mpPeldev
    remove_column :ord_trabs, :mpImp
    remove_column :ord_trabs, :mpImpq
    remove_column :ord_trabs, :mpImpdev
    remove_column :ord_trabs, :mpMgr
    remove_column :ord_trabs, :mpMgrq
    remove_column :ord_trabs, :mpMgrdev
    remove_column :ord_trabs, :mpOpt
    remove_column :ord_trabs, :mpOptq
    remove_column :ord_trabs, :mpOptdev
    remove_column :ord_trabs, :mpPtr
    remove_column :ord_trabs, :mpPtrq
    remove_column :ord_trabs, :mpPtrdev
  end
end
