(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-z0-9]{32})$
(assert (str.in_re X (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$
(assert (not (str.in_re X (re.++ (re.* (str.to_re " ")) (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (re.* (str.to_re " ")) (re.union (str.to_re "a") (str.to_re "p") (str.to_re "A") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")) (re.* (str.to_re " ")) (str.to_re "\u{0a}")))))
; <img\s((width|height|alt|align|style)="[^"]*"\s)*src="(\/?[a-z0-9_-]\/?)+\.(png|jpg|jpeg|gif)"(\s(width|height|alt|align|style)="[^"]*")*\s*\/>
(assert (not (str.in_re X (re.++ (str.to_re "<img") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.* (re.++ (re.union (str.to_re "width") (str.to_re "height") (str.to_re "alt") (str.to_re "align") (str.to_re "style")) (str.to_re "=\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "src=\u{22}") (re.+ (re.++ (re.opt (str.to_re "/")) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")) (re.opt (str.to_re "/")))) (str.to_re ".") (re.union (str.to_re "png") (str.to_re "jpg") (str.to_re "jpeg") (str.to_re "gif")) (str.to_re "\u{22}") (re.* (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (str.to_re "width") (str.to_re "height") (str.to_re "alt") (str.to_re "align") (str.to_re "style")) (str.to_re "=\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/>\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
