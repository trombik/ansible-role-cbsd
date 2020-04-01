require "spec_helper"

package = "cbsd"
service = "cbsdd"
workdir = "/usr/local/jails"
confdir = "/usr/local/etc/cbsd"
initenv_file = "#{confdir}/initenv.conf"

describe package(package) do
  it { should be_installed }
end

describe file("/etc/rc.conf.d/cbsdd") do
  it { should be_file }
  it { should be_mode 644 }
  its(:content) { should match(/^cbsd_workdir="#{ Regexp.escape(workdir) }"$/) }
end

describe file(confdir) do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
end
describe file(initenv_file) do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
  its(:content) { should match(/^# Managed by ansible/) }
  its(:content) { should match(/^nodename="auto"$/) }
end

describe file(workdir) do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
end

describe service(service) do
  it { should be_enabled }
  it { should be_running }
end

describe command("env NOCOLOR=1 workdir='#{workdir}' cbsd jls") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(/^$/) }
  its(:stdout) { should match(/^JNAME\s+JID\s+IP4_ADDR\s+HOST_HOSTNAME\s+PATH\s+STATUS$/) }
end

describe command("env NOCOLOR=1 workdir='#{workdir}' cbsd -c 'cbsdsqlrw local \"SELECT 1\"'") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(/^$/) }
  its(:stdout) { should match(/^1$/) }
end

describe file "#{workdir}/etc/defaults/jail-freebsd-puppet.conf" do
  it { should_not exist }
end

describe file "#{workdir}/etc/defaults/jail-freebsd-myprofile.conf" do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by "cbsd" }
  it { should be_grouped_into "cbsd" }
  its(:content) { should match(/# Managed by ansible/) }
  its(:content) { should match(/^jail_profile=/) }
end
