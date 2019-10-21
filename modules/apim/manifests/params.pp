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

# Class apim::params
# This class includes all the necessary parameters.
class apim::params {

  $user = 'wso2carbon'
  $user_id = 802
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 802
  $service_name = 'wso2am'
  $hostname = 'ALB_DNS_NAME'
  $mgt_hostname = 'ALB_DNS_NAME'
  $enable_test_mode = 'ENABLE_TEST_MODE'
  $jdk_version = 'JDK_TYPE'
  $db_managment_system = 'mysql'
  $oracle_sid = 'WSO2AMDB'
  $db_password = 'CF_DB_PASSWORD'
  $aws_access_key = 'ACCESS_KEY'
  $aws_secret_key = 'SECRET_KEY'
  $aws_region = 'REGION_NAME'
  $local_member_host = 'LOCAL-MEMBER-HOST'
  $http_proxy_port  = '80'
  $https_proxy_port = '443'
  $am_package = 'wso2am-2.6.0.zip'

  # Define the template
  $start_script_template = 'bin/wso2server.sh'

  $template_list = [
    'repository/conf/api-manager.xml',
    'repository/conf/datasources/master-datasources.xml',
    'repository/conf/carbon.xml',
    'repository/conf/registry.xml',
    'repository/conf/user-mgt.xml',
    'repository/conf/axis2/axis2.xml',
    'repository/conf/identity/identity.xml',
    # 'repository/conf/security/authenticators.xml',
    'repository/conf/tomcat/catalina-server.xml',
  ]

  # Configuration Params
  if $jdk_version == 'Oracle_JDK8' {
    $jdk_type = "jdk-8u144-linux-x64.tar.gz"
    $jdk_path = "jdk1.8.0_144"
  } elsif $jdk_version == 'Open_JDK8' {
    $jdk_type = "jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz"
    $jdk_path = "jdk1.8.0_192"
  }

  # ----- api-manager.xml config params -----
  $auth_manager = {
    server_url                => 'https://localhost:${mgt.transport.https.port}${carbon.context}services/',
    username                  => '${admin.username}',
    password                  => '${admin.password}',
    check_permission_remotely => 'false'
  }

  $api_gateway = {
    server_url          => 'https://localhost:${mgt.transport.https.port}${carbon.context}services/',
    username            => '${admin.username}',
    password            => '${admin.password}',
    gateway_endpoint    => 'http://ALB_DNS_NAME:${http.nio.port},https://ALB_DNS_NAME:${https.nio.port}',
    gateway_ws_endpoint => 'ws://${carbon.local.ip}:9099'
  }

  $api_store = {
    url        => 'https://ALB_DNS_NAME:${mgt.transport.https.port}/store',
    server_url => 'https://ALB_DNS_NAME:${mgt.transport.https.port}${carbon.context}services/',
    username   => '${admin.username}',
    password   => '${admin.password}'
  }

  $api_publisher = {
    url => 'https://ALB_DNS_NAME:${mgt.transport.https.port}/publisher'
  }

  # ----- Master-datasources config params -----

  if $db_managment_system == 'mysql' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $am_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:mysql://RDS_DNS_NAME:3306/WSO2AM_REG_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_um_db_url = 'jdbc:mysql://RDS_DNS_NAME:3306/WSO2AM_USER_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_am_db_url = 'jdbc:mysql://RDS_DNS_NAME:3306/WSO2AM_DB?autoReconnect=true&amp;useSSL=false'
    $db_driver_class_name = 'com.mysql.jdbc.Driver'
    $db_connector = 'mysql-connector-java-5.1.41-bin.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system =~ 'oracle' {
    $reg_db_user_name = 'WSO2AM_COMMON_DB'
    $um_db_user_name = 'WSO2AM_COMMON_DB'
    $am_db_user_name = 'WSO2AM_APIMGT_DB'
    $wso2_reg_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_um_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_am_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $db_driver_class_name = 'oracle.jdbc.OracleDriver'
    $db_validation_query = 'SELECT 1 FROM DUAL'
    $db_connector = 'ojdbc8.jar'
  } elsif $db_managment_system == 'sqlserver-se' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $am_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2AM_COMMON_DB;SendStringParametersAsUnicode=false'
    $wso2_um_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2AM_COMMON_DB;SendStringParametersAsUnicode=false'
    $wso2_am_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2AM_APIMGT_DB;SendStringParametersAsUnicode=false'
    $db_driver_class_name = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
    $db_connector = 'mssql-jdbc-7.0.0.jre8.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system == 'postgres' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $am_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2AM_COMMON_DB'
    $wso2_um_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2AM_COMMON_DB'
    $wso2_am_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2AM_APIMGT_DB'
    $db_driver_class_name = 'org.postgresql.Driver'
    $db_connector = 'postgresql-42.2.5.jar'
    $db_validation_query = 'SELECT 1; COMMIT'
  }

  $wso2_am_db = {
    url               => $wso2_am_db_url,
    username          => $am_db_user_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $wso2_um_db = {
    url               => $wso2_um_db_url,
    username          => $um_db_user_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $wso2_reg_db = {
    url               => $wso2_reg_db_url,
    username          => $reg_db_user_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  # ----- Carbon.xml config params -----
  $ports = {
    offset => 0
  }

  $key_store = {
    location     => '${carbon.home}/repository/resources/security/wso2carbon.jks',
    type         => 'JKS',
    password     => 'wso2carbon',
    key_alias    => 'wso2carbon',
    key_password => 'wso2carbon',
  }

  $trust_store = {
    location => '${carbon.home}/repository/resources/security/client-truststore.jks',
    type     => 'JKS',
    password => 'wso2carbon'
  }

  # ------ Axis2.xml config params -----
  $clustering               = {
    enabled => false,
  }
}
