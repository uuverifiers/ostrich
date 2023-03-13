(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$
(assert (str.in_re X (re.++ (re.opt (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.comp (re.range "0" "9"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(http(s?):\/\/)(www.)?(\w|-)+(\.(\w|-)+)*((\.[a-zA-Z]{2,3})|\.(aero|coop|info|museum|name))+(\/)?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "www") re.allchar)) (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.union (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re ".") (re.union (str.to_re "aero") (str.to_re "coop") (str.to_re "info") (str.to_re "museum") (str.to_re "name"))))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}http") (re.opt (str.to_re "s")) (str.to_re "://")))))
(check-sat)
