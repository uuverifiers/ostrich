(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Download\d+ocllceclbhs\u{2f}gth
(assert (str.in_re X (re.++ (str.to_re "Download") (re.+ (re.range "0" "9")) (str.to_re "ocllceclbhs/gth\u{0a}"))))
; /\u{2e}hlp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.hlp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; httphost\dActivityfilename=\u{22}
(assert (not (str.in_re X (re.++ (str.to_re "httphost") (re.range "0" "9") (str.to_re "Activityfilename=\u{22}\u{0a}")))))
; `.*?((http|ftp|https)://[\w#$&+,\/:;=?@.-]+)[^\w#$&+,\/:;=?@.-]*?`i
(assert (not (str.in_re X (re.++ (str.to_re "`") (re.* re.allchar) (re.* (re.union (str.to_re "#") (str.to_re "$") (str.to_re "&") (str.to_re "+") (str.to_re ",") (str.to_re "/") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "?") (str.to_re "@") (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "`i\u{0a}") (re.union (str.to_re "http") (str.to_re "ftp") (str.to_re "https")) (str.to_re "://") (re.+ (re.union (str.to_re "#") (str.to_re "$") (str.to_re "&") (str.to_re "+") (str.to_re ",") (str.to_re "/") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "?") (str.to_re "@") (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; (077|078|079)\s?\d{2}\s?\d{6}
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}07") (re.union (str.to_re "7") (str.to_re "8") (str.to_re "9"))))))
(check-sat)
