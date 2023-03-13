(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; stats\u{2e}drivecleaner\u{2e}comExciteasdbiz\x2Ebiz
(assert (not (str.in_re X (str.to_re "stats.drivecleaner.com\u{13}Exciteasdbiz.biz\u{0a}"))))
; /\/i\.html\?[a-z0-9]+\=[a-zA-Z0-9]{25}/U
(assert (str.in_re X (re.++ (str.to_re "//i.html?") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 25 25) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; www\x2Ealtnet\x2EcomHost\x3ANSIS_DOWNLOADSubject\x3AUser-Agent\x3Awww\x2Esearchingall\x2Ecom
(assert (str.in_re X (str.to_re "www.altnet.com\u{1b}Host:NSIS_DOWNLOADSubject:User-Agent:www.searchingall.com\u{0a}")))
(check-sat)
