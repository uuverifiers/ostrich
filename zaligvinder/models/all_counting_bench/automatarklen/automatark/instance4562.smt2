(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; on\dName=Your\+Host\+is\x3AcdpViewHost\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "on") (re.range "0" "9") (str.to_re "Name=Your+Host+is:cdpViewHost:User-Agent:\u{0a}"))))
; Uin=\s+\.htaServerTheef2trustyfiles\x2EcomlogsHost\x3A
(assert (str.in_re X (re.++ (str.to_re "Uin=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".htaServerTheef2trustyfiles.comlogsHost:\u{0a}"))))
; u=with\x3AHBand,Deathhoroscope2
(assert (str.in_re X (str.to_re "u=with:HBand,Deathhoroscope2\u{0a}")))
; ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?$
(assert (not (str.in_re X (re.++ (re.* (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "."))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
