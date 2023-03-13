(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9][0-9]{1,6}\-[0-9]{2}\-[0-9]
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 1 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; ^(\(?[0-9]{3}[\)-\.]?\ ?)?[0-9]{3}[-\.]?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.range ")" ".")) (re.opt (str.to_re " ")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\x2Emaxifiles\x2EcomServidor\x2E
(assert (not (str.in_re X (str.to_re "www.maxifiles.comServidor.\u{13}\u{0a}"))))
; freeIPaddrsRunner\+The\+password\+is\x3A
(assert (not (str.in_re X (str.to_re "freeIPaddrsRunner+The+password+is:\u{0a}"))))
; /(((ftp|http|https):\/\/)|(\w+:{0,1}\w*@))?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (re.++ (re.union (str.to_re "ftp") (str.to_re "http") (str.to_re "https")) (str.to_re "://")) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ":")) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@")))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.union (str.to_re "#") (str.to_re "!") (str.to_re ":") (str.to_re ".") (str.to_re "?") (str.to_re "+") (str.to_re "=") (str.to_re "&") (str.to_re "%") (str.to_re "@") (str.to_re "-") (str.to_re "/") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "/\u{0a}"))))
(check-sat)
