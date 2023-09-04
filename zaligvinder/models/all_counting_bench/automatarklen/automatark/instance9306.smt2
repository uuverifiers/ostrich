(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{1,2})\W+(\d{1,2})\W*(\d{2,4})?|(\d{4})\W(\d{1,2})\W(\d{1,2})|([a-zA-Z]+)\W*(\d{1,2})\W+(\d{2,4})|(\d{4})\W*([a-zA-Z]+)\W*(\d{1,2})|(\d{1,2})\W*([a-zA-Z]+)\W*(\d{2,4})|(\d{1,2})\W*([a-zA-Z]+)|([a-zA-Z]+)\W*(\d{1,2})|(\d{2})(\d{2})(\d{2,4})?
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.+ (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.opt ((_ re.loop 2 4) (re.range "0" "9")))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 1 2) (re.range "0" "9")) (re.+ (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 2 4) (re.range "0" "9"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 2 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt ((_ re.loop 2 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /filename\s*=\s*[^\r\n]*?\u{2e}mcl[\u{22}\u{27}\u{3b}\s\r\n]/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ".mcl") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/i\u{0a}")))))
; TOOLBAR\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "TOOLBAR") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}"))))
; ^([A-z]{2}\d{7})|([A-z]{4}\d{10})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "z")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.range "A" "z")) ((_ re.loop 10 10) (re.range "0" "9")))))))
; ^((\\\\[a-zA-Z0-9-]+\\[a-zA-Z0-9`~!@#$%^&(){}'._-]+([ ]+[a-zA-Z0-9`~!@#$%^&(){}'._-]+)*)|([a-zA-Z]:))(\\[^ \\/:*?""<>|]+([ ]+[^ \\/:*?""<>|]+)*)*\\?$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "\u{5c}\u{5c}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "\u{5c}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "{") (str.to_re "}") (str.to_re "'") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (re.* (re.++ (re.+ (str.to_re " ")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "{") (str.to_re "}") (str.to_re "'") (str.to_re ".") (str.to_re "_") (str.to_re "-")))))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":"))) (re.* (re.++ (str.to_re "\u{5c}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (re.* (re.++ (re.+ (str.to_re " ")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))))))) (re.opt (str.to_re "\u{5c}")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)