(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}\s+OnlineServer\u{3a}Yeah\!User-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OnlineServer:Yeah!User-Agent:\u{0a}"))))
; ^[a-zA-Z0-9._-]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; [^0-9]((\(?(\+420|00420)\)?( |-)?)?([0-9]{3} ?(([0-9]{3} ?[0-9]{3})|([0-9]{2} ?[0-9]{2} ?[0-9]{2})))|([0-9]{3}-(([0-9]{3}-[0-9]{3})|([0-9]{2}-[0-9]{2}-[0-9]{2}))))[^0-9|/]
(assert (str.in_re X (re.++ (re.range "0" "9") (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) (re.union (str.to_re "+420") (str.to_re "00420")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))) (re.union (re.range "0" "9") (str.to_re "|") (str.to_re "/")) (str.to_re "\u{0a}"))))
; /\u{2e}tte([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.tte") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
