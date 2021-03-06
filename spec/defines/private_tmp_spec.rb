require 'spec_helper'

describe 'bamboo_agent::private_tmp' do

  let :title do '/footmp' end

  let(:params) do
    {
      :user     => 'jdoe', 
      :group    => 'jdoe',
    }
  end 
  
  let(:facts) do
  {
      :osfamily => 'debian', 
  }
  end 

  it do
    should contain_file('/footmp').with({
      :ensure => 'directory',
      :owner  => 'jdoe',
      :group  => 'jdoe',
      :mode   => '0755',
    })
    should contain_package('tmpreaper')
    should contain_cron('/footmp-tmp-cleanup').with({
      :command => '/usr/sbin/tmpreaper 1d /footmp -a -T 120',
      :minute  => 0,
      :hour    => 4,
    })
  end
  
  context 'non ubuntu' do
	  let(:facts) do
	  {
	      :osfamily => 'RedHat', 
	  }
	  end 

	  it do
	    should contain_file('/footmp').with({
	      :ensure => 'directory',
	      :owner  => 'jdoe',
	      :group  => 'jdoe',
	      :mode   => '0755',
	    })
	    should contain_package('tmpwatch')
	    should contain_cron('/footmp-tmp-cleanup').with({
	      :command => '/usr/sbin/tmpwatch 1d /footmp -a -T 120',
	      :minute  => 0,
	      :hour    => 4,
	    })
	  end
  end
end
