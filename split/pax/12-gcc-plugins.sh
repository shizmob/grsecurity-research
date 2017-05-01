diff --git a/Kbuild b/Kbuild
index 3d0ae15..84e5412 100644
--- a/Kbuild
+++ b/Kbuild
@@ -91,6 +91,7 @@ $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s FORCE
 always += missing-syscalls
 targets += missing-syscalls
 
+GCC_PLUGINS_missing-syscalls := n
 quiet_cmd_syscalls = CALL    $<
       cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags) $(missing_syscalls_flags)
 
diff --git a/Makefile b/Makefile
index 50436f5..435d355 100644
--- a/Makefile
+++ b/Makefile
@@ -1274,7 +1276,10 @@ MRPROPER_FILES += .config .config.old .version .old_version \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.pem signing_key.priv signing_key.x509	\
 		  x509.genkey extra_certificates signing_key.x509.keyid	\
-		  signing_key.x509.signer vmlinux-gdb.py
+		  signing_key.x509.signer vmlinux-gdb.py \
+		  scripts/gcc-plugins/size_overflow_plugin/e_*.h \
+		  scripts/gcc-plugins/size_overflow_plugin/disable.h \
+		  scripts/gcc-plugins/randomize_layout_seed.h
 
 # clean - Delete most, but leave enough to build external modules
 #
diff --git a/arch/Kconfig b/arch/Kconfig
index 659bdd0..4179181 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -355,7 +356,7 @@ config HAVE_GCC_PLUGINS
 menuconfig GCC_PLUGINS
 	bool "GCC plugins"
 	depends on HAVE_GCC_PLUGINS
-	depends on !COMPILE_TEST
+	default y
 	help
 	  GCC plugins are loadable modules that provide extra features to the
 	  compiler. They are useful for runtime instrumentation and static analysis.
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index d50430c..39509a6 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -24,6 +24,8 @@ endif
 
 GCOV_PROFILE		:= n
 
+GCC_PLUGINS		:= n
+
 #
 # Architecture dependencies
 #
