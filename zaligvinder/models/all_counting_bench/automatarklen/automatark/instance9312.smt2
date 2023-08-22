(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((Sir|Dr.|Mr.|Mrs.|Ms.|Rev.){1}[ ]?)?([A-Z]{1}[.]{1}([A-Z]{1}[.]{1})?|[A-Z]{1}[a-z]{1,}|[A-Z]{1}[a-z]{1,}[-]{1}[A-Z]{1}[a-z]{1,}|[A-Z]{1}[a-z]{0,}[ ]{1}[A-Z]{1}[a-z]{0,}){1}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 1 1) (re.union (str.to_re "Sir") (re.++ (str.to_re "Dr") re.allchar) (re.++ (str.to_re "Mr") re.allchar) (re.++ (str.to_re "Mrs") re.allchar) (re.++ (str.to_re "Ms") re.allchar) (re.++ (str.to_re "Rev") re.allchar))) (re.opt (str.to_re " ")))) ((_ re.loop 1 1) (re.union (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re ".")) (re.opt (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "."))))) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.+ (re.range "a" "z"))) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.+ (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 1 1) (re.range "A" "Z")) (re.+ (re.range "a" "z"))) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.* (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 1 1) (re.range "A" "Z")) (re.* (re.range "a" "z"))))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}xslt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xslt/i\u{0a}"))))
; for\x2Fproducts\x2Fspyblocs\x2FHost\x3Aocllceclbhs\u{2f}gth
(assert (str.in_re X (str.to_re "for/products/spyblocs/\u{13}Host:ocllceclbhs/gth\u{0a}")))
; Host\x3Ahirmvtg\u{2f}ggqh\.kqhverA-Spy
(assert (str.in_re X (str.to_re "Host:hirmvtg/ggqh.kqh\u{1b}verA-Spy\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
