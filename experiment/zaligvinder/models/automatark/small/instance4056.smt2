(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3ADIMBUSsidebar\.activeshopper\.comUser-Agent\x3APcast
(assert (str.in_re X (str.to_re "Host:DIMBUSsidebar.activeshopper.comUser-Agent:Pcast\u{0a}")))
; [$][0 -9]+
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.+ (re.union (str.to_re "0") (re.range " " "9"))) (str.to_re "\u{0a}")))))
; /^\/\w{1,2}\/\w{1,3}\.class$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".class/U\u{0a}")))))
; (^([\w]+[^\W])([^\W]\.?)([\w]+[^\W]$))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; ^([0-9][0-9])[.]([0-9][0-9])[.]([0-9][0-9])$
(assert (not (str.in_re X (re.++ (str.to_re "..\u{0a}") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9")))))
(check-sat)
