(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /php\?jnlp\=[a-f0-9]{10}($|\u{2c})/U
(assert (not (str.in_re X (re.++ (str.to_re "/php?jnlp=") ((_ re.loop 10 10) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ",/U\u{0a}")))))
; /filename=[^\n]*\u{2e}pui/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pui/i\u{0a}")))))
; Host\x3A.*rt[^\n\r]*Host\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "rt") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:User-Agent:\u{0a}"))))
; ^(([0]?[1-9]|1[0-2])/([0-2]?[0-9]|3[0-1])/[1-2]\d{3})? ?((([0-1]?\d)|(2[0-3])):[0-5]\d)?(:[0-5]\d)? ?(AM|am|PM|pm)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (re.range "0" "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.range "1" "2") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (str.to_re " ")) (re.opt (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (str.to_re " ")) (re.opt (re.union (str.to_re "AM") (str.to_re "am") (str.to_re "PM") (str.to_re "pm"))) (str.to_re "\u{0a}"))))
; sponsor2\.ucmore\.comUser-Agent\x3AUser-Agent\x3A
(assert (str.in_re X (str.to_re "sponsor2.ucmore.comUser-Agent:User-Agent:\u{0a}")))
(check-sat)
