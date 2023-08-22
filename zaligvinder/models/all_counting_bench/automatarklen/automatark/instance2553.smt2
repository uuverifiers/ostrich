(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\$?)((\d{1,20})|(\d{1,2}((,?\d{3}){0,6}))|(\d{3}((,?\d{3}){0,5})))$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union ((_ re.loop 1 20) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 0 6) (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 5) (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; YAHOODesktopHost\u{3a}LOGHost\x3AtvshowticketsResultsFROM\x3A
(assert (str.in_re X (str.to_re "YAHOODesktopHost:LOGHost:tvshowticketsResultsFROM:\u{0a}")))
; /(Windows Phone|iPhone|BlackBerry|Mobile|Android|Opera Mini|Opera Mobile|SymbianOS)/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "Windows Phone") (str.to_re "iPhone") (str.to_re "BlackBerry") (str.to_re "Mobile") (str.to_re "Android") (str.to_re "Opera Mini") (str.to_re "Opera Mobile") (str.to_re "SymbianOS")) (str.to_re "/\u{0a}")))))
; ^\<(\w){1,}\>(.){0,}([\</]|[\<])(\w){1,}\>$
(assert (str.in_re X (re.++ (str.to_re "<") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ">") (re.* re.allchar) (re.union (str.to_re "<") (str.to_re "/")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ">\u{0a}"))))
; ^([^S]|S[^E]|SE[^P]).*
(assert (not (str.in_re X (re.++ (re.union (re.comp (str.to_re "S")) (re.++ (str.to_re "S") (re.comp (str.to_re "E"))) (re.++ (str.to_re "SE") (re.comp (str.to_re "P")))) (re.* re.allchar) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
