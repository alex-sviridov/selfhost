- [03] dynamic ip range from 
    "--entryPoints.websecure.forwardedHeaders.trustedIPs={{ 
              (cat 
                (exec "curl" (list "-s" "https://www.cloudflare.com/ips-v4")) 
                (exec "curl" (list "-s" "https://www.cloudflare.com/ips-v6"))
              ) | trim | replace \"\n\" \",\" 
            }}"


- [03] install crd on stage2, so we can move certificates from extraobjects in traefik, for instance, because it would not work because crd is not installed during initial provisioning