~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"]wyUI@SmJTDM3fiv:@vshZL8;~Zc1&|IQT;Jt0@]?I7%|jz%[bh!d9p}t)iDeCHV"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: String.to_atom(System.get_env("COOKIE"))
  set vm_args: "rel/vm.args"
end

release :nyon do
  set version: current_version(:nyon)
  set applications: [
    :runtime_tools
  ]
end
