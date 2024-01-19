(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/stat_svc\/$/U
(assert (str.in_re X (str.to_re "//stat_svc//U\u{0a}")))
; ^([_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,})))(;[ ]?[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,})))*$
(assert (not (str.in_re X (re.++ (re.* (re.++ (str.to_re ";") (re.opt (str.to_re " ")) (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re ".") (re.union ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))))) (str.to_re "\u{0a}") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re ".") (re.union ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z")))))))))
; User-Agent\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
; Host\x3A\supgrade\x2Eqsrch\x2Einfox2Fie\.aspdcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "upgrade.qsrch.infox2Fie.aspdcww.dmcast.com\u{0a}")))))
; search\u{2e}conduit\u{2e}com\sPARSER.*
(assert (str.in_re X (re.++ (str.to_re "search.conduit.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSER") (re.* re.allchar) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
