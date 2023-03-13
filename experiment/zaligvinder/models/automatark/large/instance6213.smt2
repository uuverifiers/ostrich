(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\w+)s?\:\/\/(\w+)?(\.)?(\w+)?\.(\w+)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re "s")) (str.to_re "://") (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.opt (str.to_re ".")) (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /RegExp?\u{23}.{0,5}\u{28}\u{3f}[^\u{29}]{0,4}i.*?\u{28}\u{3f}\u{2d}[^\u{29}]{0,4}i.{0,50}\u{7c}\u{7c}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/RegEx") (re.opt (str.to_re "p")) (str.to_re "#") ((_ re.loop 0 5) re.allchar) (str.to_re "(?") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") (re.* re.allchar) (str.to_re "(?-") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") ((_ re.loop 0 50) re.allchar) (str.to_re "||/smi\u{0a}")))))
; [a-zA-Z_:][a-zA-Z0-9_,\.\-]*?
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re ":")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re ",") (str.to_re ".") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; /(^|&)(db(username|password|)|cp(username|password|domain))=[^&]*?(\u{27}|%27)[^&]*?([\u{3b}\u{60}]|\u{24}\u{28}|%3b|%60|%24%28)/Pmi
(assert (str.in_re X (re.++ (str.to_re "/&") (re.union (re.++ (str.to_re "db") (re.union (str.to_re "username") (str.to_re "password"))) (re.++ (str.to_re "cp") (re.union (str.to_re "username") (str.to_re "password") (str.to_re "domain")))) (str.to_re "=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "'") (str.to_re "%27")) (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "$(") (str.to_re "%3b") (str.to_re "%60") (str.to_re "%24%28") (str.to_re ";") (str.to_re "`")) (str.to_re "/Pmi\u{0a}"))))
; ^([Vv]+(erdade(iro)?)?|[Ff]+(als[eo])?|[Tt]+(rue)?|0|[\+\-]?1)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.+ (re.union (str.to_re "V") (str.to_re "v"))) (re.opt (re.++ (str.to_re "erdade") (re.opt (str.to_re "iro"))))) (re.++ (re.+ (re.union (str.to_re "F") (str.to_re "f"))) (re.opt (re.++ (str.to_re "als") (re.union (str.to_re "e") (str.to_re "o"))))) (re.++ (re.+ (re.union (str.to_re "T") (str.to_re "t"))) (re.opt (str.to_re "rue"))) (str.to_re "0") (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (str.to_re "1"))) (str.to_re "\u{0a}"))))
(check-sat)
