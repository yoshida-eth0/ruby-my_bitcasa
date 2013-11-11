require 'my_bitcasa/download'
require 'active_support/core_ext'
require 'cgi'
require 'fileutils'
require 'tempfile'

module MyBitcasa
  module Downloadable
    extend ActiveSupport::Concern

    def stream(&block)
      # path
      download = Download.new(_download_path, _download_params)
      download.stream(&block)
    end

    def save(dest_path, use_tempfile=true)
      download = Download.new(_download_path, _download_params, _download_basename)
      download.save(dest_path, use_tempfile)
    end

    # downloadable info

    def _download_path
      path_proc = self.class.downloadable_path_proc
      instance_eval &path_proc
    end
    private :_download_path

    def _download_params
      params_proc = self.class.downloadable_params_proc
      instance_eval &params_proc
    end
    private :_download_params

    def _download_basename
      basename_proc = self.class.downloadable_basename_proc
      instance_eval &basename_proc
    end
    private :_download_basename

    module ClassMethods
      attr_reader :downloadable_path_proc
      attr_reader :downloadable_params_proc
      attr_reader :downloadable_basename_proc

      def downloadable_path(&block)
        @downloadable_path_proc = block
      end

      def downloadable_params(&block)
        @downloadable_params_proc = block
      end

      def downloadable_basename(&block)
        @downloadable_basename_proc = block
      end
    end
  end
end
