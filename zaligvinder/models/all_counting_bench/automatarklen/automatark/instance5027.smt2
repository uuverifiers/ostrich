(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(http(s?):\/\/)(www.)?(\w|-)+(\.(\w|-)+)*((\.[a-zA-Z]{2,3})|\.(aero|coop|info|museum|name))+(\/)?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "www") re.allchar)) (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.union (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re ".") (re.union (str.to_re "aero") (str.to_re "coop") (str.to_re "info") (str.to_re "museum") (str.to_re "name"))))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}http") (re.opt (str.to_re "s")) (str.to_re "://")))))
; ^(([a-zA-Z]:)|((\\|/){1,2}\w+)\$?)((\\|/)(\w[\w ]*.*))+\.([a-zA-Z0-9]+)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 1 2) (re.union (str.to_re "\u{5c}") (str.to_re "/"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.++ (re.union (str.to_re "\u{5c}") (str.to_re "/")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar))) (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; (\\.|[^"])*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{0a}")))))
; ^[1-9]{1}[0-9]{3}\s{0,1}?[a-zA-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
