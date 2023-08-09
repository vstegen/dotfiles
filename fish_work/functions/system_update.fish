function system_update -d "Update system via topgrade"
  remove_ds_store
  topgrade
end
