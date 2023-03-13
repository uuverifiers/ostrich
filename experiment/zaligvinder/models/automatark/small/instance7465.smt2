(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mswmm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mswmm/i\u{0a}"))))
; ^[-+]?[0-9]\d{0,2}(\.\d{1,2})?%?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.range "0" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.opt (str.to_re "%")) (str.to_re "\u{0a}"))))
; \x2Fta\x2FNEWS\x2Fpassword\x3B1\x3BOptix
(assert (not (str.in_re X (str.to_re "/ta/NEWS/password;1;Optix\u{0a}"))))
; Xtrawww\x2Einstafinder\x2EcomsearchHost\x3A
(assert (not (str.in_re X (str.to_re "Xtrawww.instafinder.comsearchHost:\u{0a}"))))
; /[0-9a-fA-F]{8}[a-z]{6}.php/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 6 6) (re.range "a" "z")) re.allchar (str.to_re "php/\u{0a}")))))
(check-sat)
