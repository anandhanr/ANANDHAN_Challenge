
def test_httpd_pkg_installed(host):
    assert host.package("httpd").is_installed

def test_mod_ssl_pkg_installed(host):
    assert host.package("mod_ssl").is_installed

def test_httpd_service_running(host):
    httpd = host.service("httpd")
    assert httpd.is_running

def test_httpd_conf_file_exist(host):
    assert host.file("/etc/httpd/conf/httpd.conf").exists

def test_http_port_listening(host):
    http = host.socket('tcp://80')
    assert http.is_listening

def test_https_port_listening(host):
    https = host.socket('tcp://443')
    assert https.is_listening

def test_command(host):
    assert (host.check_output("curl -k https://3.228.12.175")).find("Hello World")