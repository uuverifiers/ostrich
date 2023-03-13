(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&%\$#\=~_\-]+))*$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "://") (re.union (re.++ (re.union (str.to_re "H") (str.to_re "h")) (re.union (str.to_re "T") (str.to_re "t"))) (str.to_re "F") (str.to_re "f")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "P") (str.to_re "p")) (re.opt (re.union (str.to_re "S") (str.to_re "s"))))) (re.union (re.++ (str.to_re "www") re.allchar) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) re.allchar)) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re ",") (str.to_re ";") (str.to_re "?") (str.to_re "'") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~") (str.to_re "_") (str.to_re "-"))))) (str.to_re "\u{0a}")))))
; <body[\d\sa-z\W\S\s]*>
(assert (not (str.in_re X (re.++ (str.to_re "<body") (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">\u{0a}")))))
; /filename=[^\n]*\u{2e}mpeg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mpeg/i\u{0a}")))))
; X-Mailer\u{3a}[^\n\r]*Host\x3A\s+cyber@yahoo\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.com\u{0a}")))))
; HBand,\sHost\x3A[^\n\r]*lnzzlnbk\u{2f}pkrm\.fin
(assert (str.in_re X (re.++ (str.to_re "HBand,") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin\u{0a}"))))
(check-sat)
