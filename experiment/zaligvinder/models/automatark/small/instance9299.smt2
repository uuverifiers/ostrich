(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ehtml\s+IDENTIFY\s+\x2Fbar_pl\x2Ffav\.fcgiwwwUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re ".html") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "IDENTIFY") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/fav.fcgiwwwUser-Agent:\u{0a}"))))
; Referer\x3A\s+www\u{2e}proventactics\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.proventactics.com\u{0a}")))))
; ^((0?[1-9]|1[012])(:[0-5]\d){1,2}(\ [AaPp][Mm]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re " ") (re.union (str.to_re "A") (str.to_re "a") (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "M") (str.to_re "m")))))
; ^(([0]?[1-9]|1[0-2])/([0-2]?[0-9]|3[0-1])/[1-2]\d{3})? ?((([0-1]?\d)|(2[0-3])):[0-5]\d)?(:[0-5]\d)? ?(AM|am|PM|pm)?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (re.range "0" "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.range "1" "2") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (str.to_re " ")) (re.opt (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (str.to_re " ")) (re.opt (re.union (str.to_re "AM") (str.to_re "am") (str.to_re "PM") (str.to_re "pm"))) (str.to_re "\u{0a}")))))
; ^([A-Z]|[a-z]|[0-9])(([A-Z])*(([a-z])*([0-9])*(%)*(&)*(')*(\+)*(-)*(@)*(_)*(\.)*)|(\ )[^  ])+$
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.+ (re.union (re.++ (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "0" "9")) (re.* (str.to_re "%")) (re.* (str.to_re "&")) (re.* (str.to_re "'")) (re.* (str.to_re "+")) (re.* (str.to_re "-")) (re.* (str.to_re "@")) (re.* (str.to_re "_")) (re.* (str.to_re "."))) (re.++ (str.to_re " ") (re.comp (str.to_re " "))))) (str.to_re "\u{0a}")))))
(check-sat)
