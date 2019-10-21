# ----------------------------------------------------------------------------
#  Copyright (c) 2019 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

# Class: apim
# Init class of API Manager default profile

class apim inherits apim::params{

  # Copy configuration changes to the installed directory
  $template_list.each | String $template | {
    file { "/var/lib/jenkins/workspace/wso2am-2.6.0/${module_name}/wso2am-2.6.0/${template}":
      ensure  => file,
      mode    => '0644',
      content => template("${module_name}/carbon-home/${template}.erb")
    }
  }

  # Copy wso2server.sh to installed directory
  file { "/var/lib/jenkins/workspace/wso2am-2.6.0/${module_name}/wso2am-2.6.0/${start_script_template}":
    ensure  => file,
    mode    => '0754',
    content => template("${module_name}/carbon-home/${start_script_template}.erb")
  }

  # Copy mysql connector to the installed directory
  file { "/var/lib/jenkins/workspace/wso2am-2.6.0/${module_name}/wso2am-2.6.0/repository/components/lib/${db_connector}":
    mode   => '0754',
    source => "puppet:///modules/${module_name}/repository/components/lib/${db_connector}",
  }

}
