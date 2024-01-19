(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Address\x3A\s+SbAtsHTTP_RAT_Subject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Address:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAtsHTTP_RAT_Subject:\u{0a}")))))
; /\/AES\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (str.in_re X (re.++ (str.to_re "//AES") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}"))))
; www\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (str.to_re "www.searchreslt.com\u{0a}"))))
; /filename=[^\n]*\u{2e}hpj/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hpj/i\u{0a}")))))
; mPOPUser-Agent\x3AgotS\u{3a}Users\u{5c}PORT\x3DHXLogOnlyMGS-Internal-Web-Manager
(assert (not (str.in_re X (str.to_re "mPOPUser-Agent:gotS:Users\u{5c}PORT=HXLogOnlyMGS-Internal-Web-Manager\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
