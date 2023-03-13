(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x2Edocument\x2EinsertBefore\s*\u{28}[^\x2C]+\u{29}/smi
(assert (str.in_re X (re.++ (str.to_re "/.document.insertBefore") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ","))) (str.to_re ")/smi\u{0a}"))))
; ^(\d{1,4}?[.]{0,1}?\d{0,3}?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 4) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9"))))))
; ^[A-Z][a-z]+((eir|(n|l)h)(a|o))$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}") (re.union (str.to_re "eir") (re.++ (re.union (str.to_re "n") (str.to_re "l")) (str.to_re "h"))) (re.union (str.to_re "a") (str.to_re "o"))))))
; (\/\*(\s*|.*?)*\*\/)|(\/\/.*)
(assert (str.in_re X (re.union (re.++ (str.to_re "/*") (re.* (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar))) (str.to_re "*/")) (re.++ (str.to_re "\u{0a}//") (re.* re.allchar)))))
; \u{22}Thewebsearch\.getmirar\.com
(assert (str.in_re X (str.to_re "\u{22}Thewebsearch.getmirar.com\u{0a}")))
(check-sat)
