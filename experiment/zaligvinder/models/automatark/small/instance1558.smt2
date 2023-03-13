(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mswmm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mswmm/i\u{0a}"))))
; ^([0-9]{0,5}|[0-9]{0,5}\.[0-9]{0,3})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 0 5) (re.range "0" "9")) (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; that.*CodeguruBrowser.*CasinoBladeisInsideupdate\.cgiHost\x3A
(assert (str.in_re X (re.++ (str.to_re "that") (re.* re.allchar) (str.to_re "CodeguruBrowser") (re.* re.allchar) (str.to_re "CasinoBladeisInsideupdate.cgiHost:\u{0a}"))))
(check-sat)
