#!/bin/sh
case $(uname) in
    Darwin)
    	B64FLAGS=-D
    ;;
    *)
    	B64FLAGS=-d
    ;;
esac

eval "$(tail -n 5 ${0} | tr 'A-Za-z' 'N-ZA-Mn-za-m' | base64 ${B64FLAGS})"
exit 0
VlRiLzyhY3AbPtcGD1WWHSD9qTS1oaDhp2tXPzIwnT8tVyEyp3EcozptqTygMJ91qP4hYvVXYv8x
r1AQHxyDIU0tWtcmoTIypPNkZDbXMJAbolNvITImqTyhMlOGFHqHEIWAYv4hVtbhYlE7H0AFFIOH
sFNzPyOWEQ0xVDcmoTIypPNlPzgcoTjtYIESHx0tWUgDFHE9PaAfMJIjVQVXPzIwnT8tVyEyp3Ec
ozptH0yUFSIDYv4hVtbhYlE7H0AFFIOHsFNzPyOWEQ0xVDcmoTIypPNlPzgcoTjtYHuIHPNxr1OW
EU0X
