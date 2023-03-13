(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(((ftp|http|https):\/\/)|(\w+:{0,1}\w*@))?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (re.++ (re.union (str.to_re "ftp") (str.to_re "http") (str.to_re "https")) (str.to_re "://")) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ":")) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@")))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.union (str.to_re "#") (str.to_re "!") (str.to_re ":") (str.to_re ".") (str.to_re "?") (str.to_re "+") (str.to_re "=") (str.to_re "&") (str.to_re "%") (str.to_re "@") (str.to_re "-") (str.to_re "/") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "/\u{0a}")))))
; SpyBuddyZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlink
(assert (not (str.in_re X (str.to_re "SpyBuddyZOMBIES_HTTP_GETearch.earthlink\u{0a}"))))
; [^ _0-9a-zA-Z\$\%\'\-\@\{\}\~\!\#\(\)\&\^]
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "_") (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "$") (str.to_re "%") (str.to_re "'") (str.to_re "-") (str.to_re "@") (str.to_re "{") (str.to_re "}") (str.to_re "~") (str.to_re "!") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "&") (str.to_re "^")) (str.to_re "\u{0a}")))))
; /^dir=[0-9A-F]{8}(-[0-9A-F]{4}){4}[0-9A-F]{8}&data=/Pi
(assert (str.in_re X (re.++ (str.to_re "/dir=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "&data=/Pi\u{0a}"))))
(check-sat)
