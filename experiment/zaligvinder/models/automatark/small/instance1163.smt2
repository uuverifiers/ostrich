(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \bfor\b.*[A-Za-z][<> ][\d]
(assert (str.in_re X (re.++ (str.to_re "for") (re.* re.allchar) (re.union (re.range "A" "Z") (re.range "a" "z")) (re.union (str.to_re "<") (str.to_re ">") (str.to_re " ")) (re.range "0" "9") (str.to_re "\u{0a}"))))
; \d{2,4}
(assert (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; that.*CodeguruBrowser.*CasinoBladeisInsideupdate\.cgiHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "that") (re.* re.allchar) (str.to_re "CodeguruBrowser") (re.* re.allchar) (str.to_re "CasinoBladeisInsideupdate.cgiHost:\u{0a}")))))
(check-sat)
