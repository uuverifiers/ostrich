(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; richfind\x2Ecomdcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (str.to_re "richfind.comdcww.dmcast.com\u{0a}"))))
; /\u{2e}asx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.asx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&%\$#\=~_\-]+))*$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "://") (re.union (re.++ (re.union (str.to_re "H") (str.to_re "h")) (re.union (str.to_re "T") (str.to_re "t"))) (str.to_re "F") (str.to_re "f")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "P") (str.to_re "p")) (re.opt (re.union (str.to_re "S") (str.to_re "s"))))) (re.union (re.++ (str.to_re "www") re.allchar) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) re.allchar)) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re ",") (str.to_re ";") (str.to_re "?") (str.to_re "'") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~") (str.to_re "_") (str.to_re "-"))))) (str.to_re "\u{0a}")))))
; ^[A]$|^[C]$|^[D]$|^[F]$|^[H]$|^[K]$|^[L]$|^[M]$|^[O]$|^[P]$
(assert (not (str.in_re X (re.union (str.to_re "A") (str.to_re "C") (str.to_re "D") (str.to_re "F") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "O") (str.to_re "P\u{0a}")))))
; kwd\s+User-Agent\x3Aregister\.aspUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "kwd") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:register.aspUser-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
