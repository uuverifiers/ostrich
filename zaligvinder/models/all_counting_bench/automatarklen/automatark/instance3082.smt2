(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; URL\s+\.cfgmPOPrtCUSTOMPalToolbarUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "URL") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".cfgmPOPrtCUSTOMPalToolbarUser-Agent:\u{0a}"))))
; /filename=[^\n]*\u{2e}xps/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xps/i\u{0a}")))))
; <[^>]*\n?.*=("|')?(.*\.jpg)("|')?.*\n?[^<]*>
(assert (str.in_re X (re.++ (str.to_re "<") (re.* (re.comp (str.to_re ">"))) (re.opt (str.to_re "\u{0a}")) (re.* re.allchar) (str.to_re "=") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.* re.allchar) (re.opt (str.to_re "\u{0a}")) (re.* (re.comp (str.to_re "<"))) (str.to_re ">\u{0a}") (re.* re.allchar) (str.to_re ".jpg"))))
; ^#?([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (re.opt ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /sid=[0-9A-F]{32}/U
(assert (str.in_re X (re.++ (str.to_re "/sid=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
