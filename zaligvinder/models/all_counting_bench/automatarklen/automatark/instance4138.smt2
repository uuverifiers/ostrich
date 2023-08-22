(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/pte\.aspx\?ver=\d\.\d\.\d+\.\d\u{26}rnd=\d{5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//pte.aspx?ver=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (str.to_re "&rnd=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; Host\x3A\s+\.ico\s+Host\x3Aorigin\x3Dsidefind
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".ico") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:origin=sidefind\u{0a}")))))
; Host\x3A\w+wwwfromToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "wwwfromToolbartheServer:www.searchreslt.com\u{0a}"))))
; stats\u{2e}drivecleaner\u{2e}comExciteasdbiz\x2Ebiz
(assert (str.in_re X (str.to_re "stats.drivecleaner.com\u{13}Exciteasdbiz.biz\u{0a}")))
; Information.*Firewall\s+ised2k\u{c0}STATUS\u{c0}Server
(assert (str.in_re X (re.++ (str.to_re "Information") (re.* re.allchar) (str.to_re "Firewall") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ised2k\u{c0}STATUS\u{c0}Server\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
