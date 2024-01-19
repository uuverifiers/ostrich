(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; `.*?((http|ftp|https)://[\w#$&+,\/:;=?@.-]+)[^\w#$&+,\/:;=?@.-]*?`i
(assert (not (str.in_re X (re.++ (str.to_re "`") (re.* re.allchar) (re.* (re.union (str.to_re "#") (str.to_re "$") (str.to_re "&") (str.to_re "+") (str.to_re ",") (str.to_re "/") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "?") (str.to_re "@") (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "`i\u{0a}") (re.union (str.to_re "http") (str.to_re "ftp") (str.to_re "https")) (str.to_re "://") (re.+ (re.union (str.to_re "#") (str.to_re "$") (str.to_re "&") (str.to_re "+") (str.to_re ",") (str.to_re "/") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "?") (str.to_re "@") (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; Host\x3AFrom\u{3a}User-Agent\x3A\x2Fr\x2Fkeys\x2FkeysClient
(assert (not (str.in_re X (str.to_re "Host:From:User-Agent:/r/keys/keysClient\u{0a}"))))
; www\x2Emyarmory\x2EcomHost\u{3a}Host\u{3a}messagessearch\u{2e}imesh\u{2e}com
(assert (str.in_re X (str.to_re "www.myarmory.comHost:Host:messagessearch.imesh.com\u{0a}")))
; XP\d+Acme\s+\x2Fcbn\x2Fnode=Host\x3A\x3Fsearch\x3DversionContact
(assert (str.in_re X (re.++ (str.to_re "XP") (re.+ (re.range "0" "9")) (str.to_re "Acme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cbn/node=Host:?search=versionContact\u{0a}"))))
; ^\d{1,7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
