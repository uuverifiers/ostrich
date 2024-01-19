(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Fdesktop\x2FSystemwwwfromToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (str.to_re "/desktop/SystemwwwfromToolbartheServer:www.searchreslt.com\u{0a}"))))
; /^[0-9]\d{2,4}-\d{6,8}$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "0" "9") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
; User-Agent\x3A\dServer
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.range "0" "9") (str.to_re "Server\u{0a}")))))
; Logger.*aresflashdownloader\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Logger") (re.* re.allchar) (str.to_re "aresflashdownloader.com\u{0a}")))))
; /filename=[^\n]*\u{2e}reg/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".reg/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
