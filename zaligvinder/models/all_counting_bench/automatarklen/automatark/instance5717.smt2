(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}psd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".psd/i\u{0a}"))))
; (((s*)(ftp)(s*)|(http)(s*)|mailto|news|file|webcal):(\S*))|((www.)(\S*))
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (re.* (str.to_re "s")) (str.to_re "ftp") (re.* (str.to_re "s"))) (re.++ (str.to_re "http") (re.* (str.to_re "s"))) (str.to_re "mailto") (str.to_re "news") (str.to_re "file") (str.to_re "webcal")) (str.to_re ":") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.++ (str.to_re "\u{0a}") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "www") re.allchar))))
; /^\/f\/1\d{9}\/\d{9,10}(\/\d)+$/U
(assert (str.in_re X (re.++ (str.to_re "//f/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 9 10) (re.range "0" "9")) (re.+ (re.++ (str.to_re "/") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; (^.+\|+[A-Za-z])
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ re.allchar) (re.+ (str.to_re "|")) (re.union (re.range "A" "Z") (re.range "a" "z")))))
; [:]{1}[-~+o]?[)>]+
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ":")) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.+ (re.union (str.to_re ")") (str.to_re ">"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
