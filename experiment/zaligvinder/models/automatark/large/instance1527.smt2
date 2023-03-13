(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[A-Za-z0-9]+\/[A-Za-z0-9]+\.php\?[A-Za-z0-9\x2B\x2F\x3D]{300}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".php?") ((_ re.loop 300 300) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/Ui\u{0a}")))))
; /^("(\\"|[^"])*"|'(\\'|[^'])*'|[^\n])*(\n|$)/gm
(assert (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (str.to_re "\u{5c}\u{22}") (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.++ (str.to_re "'") (re.* (re.union (str.to_re "\u{5c}'") (re.comp (str.to_re "'")))) (str.to_re "'")) (re.comp (str.to_re "\u{0a}")))) (str.to_re "\u{0a}/gm\u{0a}"))))
; IP.*encoder\d+SAHPORT-User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "IP") (re.* re.allchar) (str.to_re "encoder") (re.+ (re.range "0" "9")) (str.to_re "SAHPORT-User-Agent:\u{0a}")))))
; ^(V-|I-)?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "V-") (str.to_re "I-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
