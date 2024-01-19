(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\n -~\r]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0a}") (re.range " " "~") (str.to_re "\u{0d}"))) (str.to_re "/P\u{0a}"))))
; User-Agent\x3A.*User-Agent\x3A.*spyblini\x2Einidata\.warezclient\.com
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "spyblini.inidata.warezclient.com\u{0a}"))))
; href\s*=\s*\"((\/)([i])(\/)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#]+)*)\"
(assert (not (str.in_re X (re.++ (str.to_re "href") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}\u{22}\u{0a}/i") (re.+ (str.to_re "/")) (re.* (re.++ (re.* (re.union (str.to_re "-") (str.to_re ".") (str.to_re ",") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re ":") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re "-") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))))
; ^[A]$|^[C]$|^[D]$|^[F]$|^[H]$|^[K]$|^[L]$|^[M]$|^[O]$|^[P]$
(assert (str.in_re X (re.union (str.to_re "A") (str.to_re "C") (str.to_re "D") (str.to_re "F") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "O") (str.to_re "P\u{0a}"))))
; ^([1-9]{1}[0-9]{0,7})+((,[1-9]{1}[0-9]{0,7}){0,1})+$
(assert (not (str.in_re X (re.++ (re.+ (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 7) (re.range "0" "9")))) (re.+ (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 7) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
